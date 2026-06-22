vim.filetype.add({
	pattern = {
		[".*%.sh%.su"] = "sh",
		[".*/templates/.*%.html"] = "htmldjango",
		[".*/app/templates/.*%.html"] = "htmldjango",
	},
	extension = {
		jinja = "htmldjango",
		jinja2 = "htmldjango",
		j2 = "htmldjango",
		d2 = "d2",
	},
})
