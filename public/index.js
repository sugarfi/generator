const def       = document.getElementById("def");
const def_btn   = document.getElementById("defBtn");
let   lastDef   = "";
def_btn.onclick = () => {
    def.textContent = "Loading definition...";
    fetch(
        "/api/def",
        {
            method: "GET",
        }
    )
    .then(r => r.text())
    .then(text => {
        def.textContent = lastDef = JSON.parse(text);
    });
};

const words    = document.getElementById("words");
const submit   = document.getElementById("submit");
submit.onclick = () => {
    if (lastDef == "") return;
    def.textContent = "Submitting...";
    fetch(
        "/api/generate",
        {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                "words": words.value.toLowerCase().split(" "),
                "def": lastDef
            })
        }
    )
    .then(r => r.text())
    .then(text => {
        words.value = "";
        def_btn.onclick(); // fight me
    });
};
