const os = require('os');
const botLoop = require('node-gameloop');
const CommandHandler = require('./handlers/CommandHandler');
const MessageHandler = require('./handlers/MessageHandler');
const StatsHandler = require('./handlers/StatsHandler');
const EventHandler = require('./handlers/EventHandler');

class Bot
{
    /*
    Initializes a new instance of the Bot
    */

    constructor(parent)
    {

        // Create Bot
        this.parent = parent
        this.bot = new Discord.Client();

        // Bot Variables
        this.id = 0;
        this.tick = 0;

        // Command Handler
        this.commands = new CommandHandler(this);
        this.msg_hndler = new MessageHandler(this);
        this.event_hndler = new EventHandler(this);
        this.stats_hndler = new StatsHandler(this);

    }

    /*
    Starts the Bot
    */

    start()
    {

        Logger.print(`Clash Bot <Build ${Config.Version}>`.green.bold);

        // Logger
        Logger.prompt(this.commands.handleCommand.bind(this.commands), Config.Logger.Prompt);

        // Good solution for minimal CPU usage
        this.loop = botLoop.setGameLoop(this.botLoop.bind(this), Config.Server.Tick);

        // System info debug
        Logger.info(`OS: ${os.platform()}`);
        Logger.info(`CPU: ${os.cpus()[0]["model"]}`);

        Logger.info(`botLoop running at ${Config.Server.Tick} ms/tick`);

        Logger.info(`Took ${process.uptime()} seconds to start`);
        Logger.info(`Type 'help' or '?' for commands \n`)

        this.login()

    }

    login()
    {
        this.bot.login(Config.Server.Token);
        this.onConnect();
    }

    onConnect()
    {
        var self = this;

        this.bot.on('ready',
        () =>
            {
                this.event_hndler.handleJoin();
            }
        );

        this.bot.on('message',
        message =>
            {
                this.msg_hndler.checkNormal(message);
            }
        );

        this.bot.on('messageReactionAdd',
        (reaction, user) =>
            {
                this.msg_hndler.handleReaction(reaction, user, 'add');
            }
        );

        this.bot.on('messageReactionRemove',
        (reaction, user) =>
            {
                this.msg_hndler.handleReaction(reaction, user, 'remove');
            }
        );

        this.bot.on('messageDelete',
        message =>
            {
                this.msg_hndler.handleDelete(message);
            }
        );

        this.bot.on('messageUpdate',
        (old_message, new_message) =>
            {
                this.msg_hndler.checkEdit(old_message, new_message);
            }
        );

        this.bot.on('guildBanAdd',
        (guild, user) =>
            {
                this.event_hndler.handleBan(guild, user);
            }
        );

        this.bot.on('guildBanRemove',
        (guild, user) =>
            {
                this.event_hndler.handleUnban(guild, user);
            }
        );

        this.bot.on('guildMemberRemove',
        (g_member) =>
            {
                this.event_hndler.handleRemoval(g_member);
            }
        );
    }

    sendMsg(message)
    {
        var guildUser = this.bot.guilds.array()[0].me;
        var channel = guildUser.guild.channels.find('name', Config.Server.Channels.Default);
        channel.send(message);
    }

    botLoop(delta)
    {
        if (this.tick >= 10)
        {
            this.tick = 0;
        }

        this.tick++;
    }
}

module.exports = Bot;
