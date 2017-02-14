Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51998 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753126AbdBNTMA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 Feb 2017 14:12:00 -0500
Date: Tue, 14 Feb 2017 20:11:57 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: fix len comparison in xfs_extent_busy_trim
Message-ID: <20170214191157.GA1162@lst.de>
References: <20170214170836.2705798-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170214170836.2705798-1-arnd@arndb.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>, Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org

Thanks Arnd, this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
