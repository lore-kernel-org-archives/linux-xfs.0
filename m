Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5EF9109
	for <linux-xfs@vger.kernel.org>; Mon,  4 Dec 2023 21:39:03 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6D7B7227A8E; Tue,  5 Dec 2023 06:39:01 +0100 (CET)
Date: Tue, 5 Dec 2023 06:39:01 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, chandanbabu@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: elide ->create_done calls for unlogged
 deferred work
Message-ID: <20231205053901.GB30199@lst.de>
References: <170175456196.3910588.9712198406317844529.stgit@frogsfrogsfrogs> <170175457355.3910588.11459425968388525930.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170175457355.3910588.11459425968388525930.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
