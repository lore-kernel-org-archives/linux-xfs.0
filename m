Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:59807 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751109AbdKTJbO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 Nov 2017 04:31:14 -0500
Date: Mon, 20 Nov 2017 10:31:12 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: fix memory leak in xfs_iext_free_last_leaf
Message-ID: <20171120093112.GA29719@lst.de>
References: <20171120090128.11320-1-shuwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171120090128.11320-1-shuwang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: shuwang@redhat.com
Cc: darrick.wong@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, bfoster@redhat.com, sandeen@redhat.com, chuhu@redhat.com, liwang@redhat.com, yizhan@redhat.com

Oops.  Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
