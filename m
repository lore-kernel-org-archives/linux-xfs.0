Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:36947 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750908AbdHaVhp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 17:37:45 -0400
MIME-Version: 1.0
In-Reply-To: <20170831213219.GC4750@magnolia>
References: <20170829142942.21594-1-agruenba@redhat.com> <20170829142942.21594-2-agruenba@redhat.com>
 <20170829161115.GS4757@magnolia> <20170831213219.GC4750@magnolia>
From: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Date: Thu, 31 Aug 2017 23:37:43 +0200
Message-ID: <CAHpGcMK6psv1Ua9ku=2+Bx-KcWyhK7f0Pw+F+8kENocv_4eKdA@mail.gmail.com>
Subject: Re: [PATCH 1/4] iomap: Switch from blkno to disk offset
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>

2017-08-31 23:32 GMT+02:00 Darrick J. Wong <darrick.wong@oracle.com>:
> FWIW I still want the BBTOB thing fixed in whatever patch lands
> upstream, but I tested the first two patches in this series and nothing
> blew up so I guess everything works ok.

Sure, I'll repost the series once I have the ext4 part working
properly. Thanks for the review and testing.

Andreas
