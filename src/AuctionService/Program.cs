using AuctionService;
using AuctionService.Data;
using MassTransit;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllers();
builder.Services.AddDbContext<AuctionDBContext>(opt => {
    opt.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection"));
});

builder.Services.AddAutoMapper(AppDomain.CurrentDomain.GetAssemblies());
builder.Services.AddMassTransit(x => 
{
    x.AddEntityFrameworkOutbox<AuctionDBContext>(o =>
    {
        o.QueryDelay = TimeSpan.FromSeconds(10);
        o.UsePostgres();
        o.UseBusOutbox();
    });
    
    x.AddConsumersFromNamespaceContaining<AuctionCreatedFaultConsumer>();
    x.SetEndpointNameFormatter(new KebabCaseEndpointNameFormatter("auction", false));

    x.UsingAzureServiceBus((context, cfg) => 
    {
        cfg.Host(builder.Configuration.GetConnectionString("AzureServiceBus"));
        cfg.ConfigureEndpoints(context);
    });
});
// Console.WriteLine($"Connection String: {builder.Configuration.GetConnectionString("DefaultConnection")}");


var app = builder.Build();

// Configure the HTTP request pipeline.
app.UseAuthorization();
app.MapControllers();

// app.UseHttpsRedirection();
try
{
    DbInitializer.InitDb(app);
    Console.WriteLine("Database initialization completed successfully.");
}
catch(Exception e)
{
    Console.WriteLine($"Exception during database initialization: {e}");
}

app.Run();
