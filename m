Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA3FLRvQ022923 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 10:21:27 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C3F991012289
	for <xfs@oss.sgi.com>; Thu,  3 Nov 2011 08:21:26 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id xPEIuhUsPZuteXyq
	for <xfs@oss.sgi.com>; Thu, 03 Nov 2011 08:21:26 -0700 (PDT)
Received: by bkbzs8 with SMTP id zs8so1464049bkb.26
	for <xfs@oss.sgi.com>; Thu, 03 Nov 2011 08:21:25 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 00/12] Bunch of new stress tests -v4
In-Reply-To: <20111103145549.GA8612@lst.de>
References: <1320330301-2682-1-git-send-email-dmonakhov@openvz.org>
	<20111103145549.GA8612@lst.de>
Date: Thu, 03 Nov 2011 19:21:21 +0400
Message-ID: <87obwtxmdq.fsf@dmbot.sw.ru>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, aelder@sgi.com, tytso@mit.edu, xfs@oss.sgi.com

On Thu, 3 Nov 2011 15:55:49 +0100, Christoph Hellwig <hch@lst.de> wrote:
> On Thu, Nov 03, 2011 at 06:24:49PM +0400, Dmitry Monakhov wrote:
> > Changes from v3 ( in request to  Christoph's comments)
> >  - hard code fsstress's options for explicit regression tests
> >  - add two new regression tests
> 
> I already have commited your first three patches to the kernel.org
> repository and various other tests that have used the nubers you're
> using.  If you want to get it in ASAP please resend, otherwise I will
> do it once I get a bit time.
Oh.. yes kernel.org, i have just forgot to switch my tree to that repo again.
No problem, Will rebase, test, and resubmit.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
