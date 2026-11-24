using StackExchange.Redis;

var connection = await ConnectionMultiplexer.ConnectAsync("localhost:6379,defaultDatabase=11");
var db = connection.GetDatabase();

await db.StringSetAsync("bike:1", "Redis", TimeSpan.FromSeconds(50));
var value = await db.StringGetAsync("bike:1");
Console.WriteLine($"bike:1     {value}");

await db.HashSetAsync("user:Nowak", new HashEntry[]
{
    new("name", "Nowak"),
    new("email", "nowak@gmail.com")
});
var email = await db.HashGetAsync("user:Nowak", "email");
Console.WriteLine($"user:Nowak {email}");
