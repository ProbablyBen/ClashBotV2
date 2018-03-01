class StatsHandler
{
    constructor(parent)
    {
        this.parent = parent;
    }

    getProfanityStats(uid)
    {
        var stats = Database.getData(`/${uid}/profanity_warnings`);
        return (stats.length - 1);
    }
}

module.exports = StatsHandler;
