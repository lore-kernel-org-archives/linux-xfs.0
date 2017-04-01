Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40047 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751791AbdDARmi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 1 Apr 2017 13:42:38 -0400
Date: Sat, 1 Apr 2017 19:42:36 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 12/26] xfs: reject all unaligned direct writes to
        reflinked files
Message-ID: <20170401174236.GA14432@lst.de>
References: <20170401063512.25313-1-hch@lst.de> <20170401063512.25313-13-hch@lst.de> <20170401172108.GA10203@kroah.com> <20170401172603.GA5701@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170401172603.GA5701@kroah.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Greg KH <greg@kroah.com>
Cc: Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>

On Sat, Apr 01, 2017 at 07:26:03PM +0200, Greg KH wrote:
> Nevermind, it's there, missed it, my fault...

And I forgot that I actually updated it for the context changes
already and even commented on that in the changelog..
