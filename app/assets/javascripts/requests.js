$(document).on("turbolinks:load", function () {
    if ($(".request_for_tenders.show").length === 0) return;


    let data = gon.participants.map(function (participant) {
        return participant.bid;
    });

    let labels = gon.participants.map(function (participant) {
       return participant.name;
    });

    let ctx = document.getElementById('barChart').getContext('2d');
    let chart = new Chart(ctx, {
        // The type of chart we want to create
        type: 'horizontalBar',

        // The data for our dataset
        data: {
            labels: labels,
            datasets: [{
                label: 'Bid Amount in $',
                backgroundColor: ['rgba(99, 99, 132, 0.5)', 'rgba(255, 99, 132, 0.5)'],
                data: data
            }]
        },

        // Configuration options go here
        options: {
            scales: {
                yAxes: [ {
                    ticks: {
                        mirror: true,
                        beginAtZero: true
                    }
                }]
            }
        }
    });
});


$(document).on("turbolinks:load", function () {
    if ($(".request_for_tenders.edit").length === 0) return;

    autosize($('textarea'));
});