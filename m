Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2C8CA
	for <linux-xfs@vger.kernel.org>; Sun,  3 Dec 2023 21:05:39 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 33A2B227A8E; Mon,  4 Dec 2023 06:05:37 +0100 (CET)
Date: Mon, 4 Dec 2023 06:05:36 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: chandanbabu@kernel.org, hch@lst.de, leo.lilong@huawei.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs: dump the recovered xattri log item if
 corruption happens
Message-ID: <20231204050536.GG26073@lst.de>
References: <170162989691.3037528.5056861908451814336.stgit@frogsfrogsfrogs> <170162989802.3037528.5252429066673340449.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170162989802.3037528.5252429066673340449.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
