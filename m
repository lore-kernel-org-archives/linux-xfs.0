Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB3BF3
	for <linux-xfs@vger.kernel.org>; Sun,  3 Dec 2023 21:11:16 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 52EB4227A8E; Mon,  4 Dec 2023 06:11:14 +0100 (CET)
Date: Mon, 4 Dec 2023 06:11:14 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: chandanbabu@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: collapse the ->finish_item helpers
Message-ID: <20231204051114.GK26073@lst.de>
References: <170162990150.3037772.1562521806690622168.stgit@frogsfrogsfrogs> <170162990215.3037772.6031433086898908600.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170162990215.3037772.6031433086898908600.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

