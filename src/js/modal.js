$(".close-modal").forEach(v =>
  v.addEventListener("click", e => {
    document.body.style.overflow = "";
    e.preventDefault();
    $(".modal.open").forEach(v =>
      v.classList.remove("open"))
    })
  );

$(".open-modal").forEach(v =>
  v.addEventListener("click", e => {
    document.body.style.overflow = "hidden";
    e.preventDefault();
    $(e.target.getAttribute("href"))[0]
      .classList.remove("open");
  })
);
