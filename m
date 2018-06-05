Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:39218 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751688AbeFEQpn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 12:45:43 -0400
Date: Tue, 5 Jun 2018 09:45:42 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] iomap: fsync swap files before iterating mappings
Message-ID: <20180605164542.GA8519@infradead.org>
References: <20180605163304.GH9437@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180605163304.GH9437@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Omar Sandoval <osandov@osandov.com>, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, Aleksei Besogonov <cyberax@amazon.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
