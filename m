Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:50448 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751489AbdF1Qlj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jun 2017 12:41:39 -0400
Date: Wed, 28 Jun 2017 18:41:37 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: Locking problems with Linux 4.9 and 4.11 with NFSD and
        `fs/iomap.c`
Message-ID: <20170628164137.GA8248@lst.de>
References: <de171adc29600902515d1424fd800678@molgen.mpg.de> <20170508131843.GB29840@bfoster.bfoster> <20170509090534.GB2378@lst.de> <7ae18b0d-38e3-9b12-0989-ede68956ad43@molgen.mpg.de> <358037e8-6784-ebca-9fbb-ec7eef3977d6@molgen.mpg.de> <20170510171757.GA10534@localhost.localdomain> <f6115b81-918d-ecfe-e3d9-812bccf7c80f@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6115b81-918d-ecfe-e3d9-812bccf7c80f@molgen.mpg.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, it+linux-nfs@molgen.mpg.de, linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>

On Tue, Jun 27, 2017 at 01:59:46PM +0200, Paul Menzel wrote:
> Dear Brian, dear Christoph,
>
>
> Just a small update that we were hit by the problem on a different machine 
> (identical model) with Linux 4.9.32 and the exact same symptoms.

Thanks for the update.  I have to admit this issue completely dropped
off my table, but I'll try to get back to it in the next days.
