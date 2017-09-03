$(document).on("turbolinks:load", function () {
    autosize($('textarea'));


    console.log(gon);

    let data = gon.participants.map(function (participant) {
        return participant.bid;
    });
    console.log(data);

    let labels = gon.participants.map(function (participant) {
       return participant.email;
    });
    console.log(labels);



    let ctx = document.getElementById('barChart').getContext('2d');
    let chart = new Chart(ctx, {
        // The type of chart we want to create
        type: 'horizontalBar',

        // The data for our dataset
        data: {
            // labels: ["January", "February", "March", "April", "May", "June", "July"],
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