Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01448C1
	for <linux-xfs@vger.kernel.org>; Sun,  3 Dec 2023 21:03:06 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 04B25227A8E; Mon,  4 Dec 2023 06:03:03 +0100 (CET)
Date: Mon, 4 Dec 2023 06:03:03 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: chandanbabu@kernel.org, hch@lst.de, leo.lilong@huawei.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: use xfs_defer_pending objects to recover
 intent items
Message-ID: <20231204050303.GD26073@lst.de>
References: <170162989691.3037528.5056861908451814336.stgit@frogsfrogsfrogs> <170162989737.3037528.16334530137884310180.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170162989737.3037528.16334530137884310180.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
