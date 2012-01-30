Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0UJvCMm113632 for <xfs@oss.sgi.com>; Mon, 30 Jan 2012 13:57:12 -0600
Received: from cartman.its.monash.edu.au (cartman.its.monash.edu.au
	[130.194.13.166]) by cuda.sgi.com with ESMTP id
	21iws2BGq5jyXpzF for <xfs@oss.sgi.com>;
	Mon, 30 Jan 2012 11:57:10 -0800 (PST)
Received: from chapman.its.monash.edu.au ([130.194.13.89])
	by cartman.its.monash.edu.au
	(Sun Java System Messaging Server 6.2-4.03 (built Sep 22 2005))
	with ESMTP id <0LYM00IYZNF8NR10@cartman.its.monash.edu.au> for
	xfs@oss.sgi.com; Tue, 31 Jan 2012 06:57:08 +1100 (EST)
Received: from chapman.its.monash.edu.au (localhost.localdomain [127.0.0.1])
	by localhost (Postfix) with SMTP id 571737E6105	for <xfs@oss.sgi.com>;
	Tue, 31 Jan 2012 06:57:08 +1100 (EST)
Received: from mail-pz0-f54.google.com
	(mail-pz0-f54.google.com [209.85.210.54])
	(using TLSv1 with cipher RC4-SHA (128/128 bits))
	(No client certificate requested)	by chapman.its.monash.edu.au
	(Postfix) with ESMTPS id D62137E6117	for <xfs@oss.sgi.com>; Tue,
	31 Jan 2012 06:57:07 +1100 (EST)
Received: by dadw1 with SMTP id w1so4590313dad.41 for <xfs@oss.sgi.com>; Mon,
	30 Jan 2012 11:57:04 -0800 (PST)
Date: Tue, 31 Jan 2012 06:57:04 +1100
From: Nathan Scott <nathans@debian.org>
Subject: Re: [PATCH] xfs_quota: remove calls to XFS_QSYNC
In-reply-to: <20120130115024.GA884@infradead.org>
Message-id: <CAAp5ZgNKsY-OrWyDNU70KUKYCZUX_EvzngAvBsBTgrgkK6KyMA@mail.gmail.com>
MIME-version: 1.0
References: <20120130115024.GA884@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 30 January 2012 22:50, Christoph Hellwig <hch@infradead.org> wrote:
> ...
> Nathan, I've cced you in case you still remember anything about this,
> although it's fairly unlikely after 6.5 years. =A0Also if anyone at SGI
> can find anything about the above commits in BugWorks additional feedback
> would be welcome.

I can't recall - but usually there was greater detail in the bugworks entry,
I think thats your best source now.

Patch looks OK to me FWIW, assuming nothing comes of the bugworks
archeology exercise.

cheers.

--
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
