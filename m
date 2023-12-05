Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C547DA1
	for <linux-xfs@vger.kernel.org>; Mon,  4 Dec 2023 20:31:46 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 630ED68B05; Tue,  5 Dec 2023 05:31:43 +0100 (CET)
Date: Tue, 5 Dec 2023 05:31:43 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: chandanbabu@kernel.org, hch@lst.de, leo.lilong@huawei.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs: don't leak recovered attri intent items
Message-ID: <20231205043143.GA28309@lst.de>
References: <170162989691.3037528.5056861908451814336.stgit@frogsfrogsfrogs> <170162989722.3037528.16617404995975433218.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170162989722.3037528.16617404995975433218.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Based on my now existent but still vague understanding of the logged
attr code:

Reviewed-by: Christoph Hellwig <hch@lst.de>
