Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53559 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753696AbdCAXMf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Mar 2017 18:12:35 -0500
Date: Thu, 2 Mar 2017 00:01:51 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] iomap: invalidate page caches should be after
        iomap_dio_complete() in direct write
Message-ID: <20170301230151.GA21627@lst.de>
References: <20170301163708.7002-1-guaneryu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170301163708.7002-1-guaneryu@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de, Eryu Guan <eguan@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
