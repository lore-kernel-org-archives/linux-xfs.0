Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39007 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752177AbdEKPGY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 May 2017 11:06:24 -0400
Date: Thu, 11 May 2017 08:06:05 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: avoid harmless gcc-7 warnings
Message-ID: <20170511150605.GA24235@infradead.org>
References: <20170511150450.2573345-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170511150450.2573345-1-arnd@arndb.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@redhat.com>, linux-kernel@vger.kernel.org

Yes, this looks much better:

Reviewed-by: Christoph Hellwig <hch@lst.de>
