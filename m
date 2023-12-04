Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32DAE6
	for <linux-xfs@vger.kernel.org>; Sun,  3 Dec 2023 21:20:02 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 03A63227A8E; Mon,  4 Dec 2023 06:19:59 +0100 (CET)
Date: Mon, 4 Dec 2023 06:19:59 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: chandanbabu@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: use xfs_defer_create_done for the relogging
 operation
Message-ID: <20231204051959.GA26448@lst.de>
References: <170162990150.3037772.1562521806690622168.stgit@frogsfrogsfrogs> <170162990246.3037772.12936129938729072380.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170162990246.3037772.12936129938729072380.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
