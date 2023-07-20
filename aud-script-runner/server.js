const { exec } = require("child_process");
const express = require("express");

const app = express();
const port = 3000;

app.use(express.static(__dirname));

//PRODUCTION SCRIPTS

app.post("/taskServerbuilds", (req, res) => {
    const arg1 = req.query.arg1;
    const arg2 = req.query.arg2;

    exec("sh Build ${arg1} ${arg2}", (error, stdout, stderr) => {
        if (error) {
            console.error(`Error: ${error.message}`);
            res.status(500).send("Error occurred while executing the script");
            return;
        }
        if (stderr) {
            console.error(`stderr: ${stderr}`);
            res.status(500).send("Error occurred while executing the script");
            return;
        }
        console.log(`stdout: ${stdout}`);
        res.send("Script executed successfully");
    });
});
app.post("/copy-rds-ss", (req, res) => {
    exec("sh rdsCp.sh", (error, stdout, stderr) => {
        if (error) {
            console.error(`Error: ${error.message}`);
            res.status(500).send("Error occurred while executing the script");
            return;
        }
        if (stderr) {
            console.error(`stderr: ${stderr}`);
            res.status(500).send("Error occurred while executing the script");
            return;
        }
        console.log(`stdout: ${stdout}`);
        res.send("Script executed successfully");
    });
});

app.post("/S3-FILES-DOWNLOAD", (req, res) => {
    exec("sh S3FilesDownload.sh", (error, stdout, stderr) => {
        if (error) {
            console.error(`Error: ${error.message}`);
            res.status(500).send("Error occurred while executing the script");
            return;
        }
        if (stderr) {
            console.error(`stderr: ${stderr}`);
            res.status(500).send("Error occurred while executing the script");
            return;
        }
        console.log(`stdout: ${stdout}`);
        res.send("Script executed successfully");
    });
});

//CODECOMMIT SCRIPTS

app.post("/CREATE-STAGING-BRANCHES", (req, res) => {
    exec("sh Wednesday/Create_Staging-branches.sh", (error, stdout, stderr) => {
        if (error) {
            console.error(`Error: ${error.message}`);
            res.status(500).send("Error occurred while executing the script");
            return;
        }
        if (stderr) {
            console.error(`stderr: ${stderr}`);
            res.status(500).send("Error occurred while executing the script");
            return;
        }
        console.log(`stdout: ${stdout}`);
        res.send("Script executed successfully");
    });
});
app.post("/CLEAR-STAGING-BRANCHES", (req, res) => {
    exec("sh Wednesday/clear-old-staging-branches.sh", (error, stdout, stderr) => {
        if (error) {
            console.error(`Error: ${error.message}`);
            res.status(500).send("Error occurred while executing the script");
            return;
        }
        if (stderr) {
            console.error(`stderr: ${stderr}`);
            res.status(500).send("Error occurred while executing the script");
            return;
        }
        console.log(`stdout: ${stdout}`);
        res.send("Script executed successfully");
    });
});

app.post("/CREATE-RELEASE-BRANCHES", (req, res) => {
    exec("sh thursday/create-uat-release-branch.sh", (error, stdout, stderr) => {
        if (error) {
            console.error(`Error: ${error.message}`);
            res.status(500).send("Error occurred while executing the script");
            return;
        }
        if (stderr) {
            console.error(`stderr: ${stderr}`);
            res.status(500).send("Error occurred while executing the script");
            return;
        }
        console.log(`stdout: ${stdout}`);
        res.send("Script executed successfully");
    });
});
app.post("/CLEAR-RELEASE-BRANCHES", (req, res) => {
    exec("sh thursday/clear-old-uat-branches.sh", (error, stdout, stderr) => {
        if (error) {
            console.error(`Error: ${error.message}`);
            res.status(500).send("Error occurred while executing the script");
            return;
        }
        if (stderr) {
            console.error(`stderr: ${stderr}`);
            res.status(500).send("Error occurred while executing the script");
            return;
        }
        console.log(`stdout: ${stdout}`);
        res.send("Script executed successfully");
    });
});

app.post("/REBOOT-RDS", (req, res) => {
    exec("sh reboot_rds.sh", (error, stdout, stderr) => {
        if (error) {
            console.error(`Error: ${error.message}`);
            res.status(500).send("Error occurred while executing the script");
            return;
        }
        if (stderr) {
            console.error(`stderr: ${stderr}`);
            res.status(500).send("Error occurred while executing the script");
            return;
        }
        console.log(`stdout: ${stdout}`);
        res.send("Script executed successfully");
    });
});

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});



