const card = document.getElementById('url-card');
const short_url = document.getElementById('short-url');
const error = document.getElementById('error-card');
const error_msg = document.getElementById('error-message');
const btn_clip = document.getElementById('btn-clip');


const request = async (originalUrl)=>{
  const regex = new RegExp('^https?://([a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,6}(/[^ ]*)?$');
  if ( !regex.test(originalUrl)){
    showError("Invalid url")
    return;
  }

  const response = await fetch(`${supabase_url}/rest/v1/rpc/shorten_url`, {
    method: 'POST',
    headers: {
      'apikey':anon_key ,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ _original: originalUrl })
  });
  if (!response.ok) {
    showError("Server error");
    return;
  }

  const data = await response.json();
  if ( data === "invalid url") {
    showError("Invalid url")
    return;
  }
  showUrl(data)
}

const showUrl = (code) => {
  card.style.display = 'inline-block'
  error.style.display = 'none'

  const url = `${short_domain}${code}`;
  short_url.textContent = url
  short_url.href = url
}

const showError = (message) => {
  error_msg.textContent = message;
  error.style.display = 'inline-block';
  card.style.display = 'none'

}

document.addEventListener('DOMContentLoaded', function () {
  const btn = document.getElementById('btn-submit');
  btn.addEventListener('click', async function (e) {
    e.preventDefault();
    const originalUrl = document.getElementById('original_url').value;
    try {
      await request(originalUrl);
    } catch (error) {
      showError("Server error")
    }
  });

  btn_clip.addEventListener('click', ()=>{
    console.log('scripts.js:48 ',short_url.textContent)
    navigator.clipboard.writeText(short_url.textContent).then(function() {
      console.log('Text copied to clipboard successfully!');
    }, function(err) {
      console.error('Could not copy text: ', err);
    });
  })
});