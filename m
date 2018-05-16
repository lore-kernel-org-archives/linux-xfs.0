Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:45158 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751366AbeEPSLX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 14:11:23 -0400
Date: Wed, 16 May 2018 11:11:22 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 2/2] iomap: don't allow holes in swapfiles
Message-ID: <20180516181122.GB31628@infradead.org>
References: <cover.1526493125.git.osandov@fb.com>
 <cdb5dc22c56b30f693741361f6d6168f97f26bc1.1526493125.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cdb5dc22c56b30f693741361f6d6168f97f26bc1.1526493125.git.osandov@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Omar Sandoval <osandov@osandov.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, Aleksei Besogonov <cyberax@amazon.com>, kernel-team@fb.com

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

And now lets get the series merged quickly so that I can rebase my
iomap series on top of this :)
