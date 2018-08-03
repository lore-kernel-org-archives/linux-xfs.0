Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44812 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732219AbeHCRQg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Aug 2018 13:16:36 -0400
Date: Fri, 3 Aug 2018 17:24:39 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fs: fix iomap_bmap position calculation
Message-ID: <20180803152439.GA29819@lst.de>
References: <78937e83-5665-11bf-14a6-7815221bf4d8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78937e83-5665-11bf-14a6-7815221bf4d8@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

I'm surprised nothing caught this earlier..
