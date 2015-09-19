Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E54D97F3F
	for <xfs@oss.sgi.com>; Sat, 19 Sep 2015 06:52:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C19AB8F8040
	for <xfs@oss.sgi.com>; Sat, 19 Sep 2015 04:52:30 -0700 (PDT)
Received: from mail-wi0-f178.google.com (mail-wi0-f178.google.com
	[209.85.212.178]) by cuda.sgi.com with ESMTP id
	7Mi9ubhmqXdsiMqE (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Sep 2015 04:52:29 -0700 (PDT)
Received: by wicge5 with SMTP id ge5so61811969wic.0
	for <xfs@oss.sgi.com>; Sat, 19 Sep 2015 04:52:27 -0700 (PDT)
Received: from minas-tirith.valinor (6.Red-95-125-218.staticIP.rima-tde.net.
	[95.125.218.6]) by smtp.gmail.com with ESMTPSA id
	mc18sm2951165wic.23.2015.09.19.04.52.25 for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Sat, 19 Sep 2015 04:52:26 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by minas-tirith.valinor (Postfix) with ESMTP id D0B0A181FEE
	for <xfs@oss.sgi.com>; Sat, 19 Sep 2015 13:52:16 +0200 (CEST)
Date: Sat, 19 Sep 2015 13:52:04 +0200 (CEST)
From: "Carlos E. R." <carlos.e.r@opensuse.org>
Subject: Re: What's up with this list?
In-Reply-To: <alpine.LSU.2.11.1509190219340.24753@minas-tirith.valinor>
Message-ID: <alpine.LSU.2.11.1509191346220.24753@minas-tirith.valinor>
References: <alpine.LSU.2.11.1409181438290.6675@Telcontar.valinor>
	<541AFB60.5030403@sgi.com>
	<alpine.LSU.2.11.1509161436390.25528@minas-tirith.valinor>
	<55FAF053.3020405@sgi.com> <55FB06E8.1020203@opensuse.org>
	<55FC3569.5020801@sgi.com> <20150918225624.GF26895@dastard>
	<alpine.LSU.2.11.1509190219340.24753@minas-tirith.valinor>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-1463758550-1134733686-1442663224=:24753"
Content-ID: <alpine.LSU.2.11.1509191350240.24753@minas-tirith.valinor>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: XFS mailing list <xfs@oss.sgi.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463758550-1134733686-1442663224=:24753
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LSU.2.11.1509191348501.24753@minas-tirith.valinor>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Content-ID: <alpine.LSU.2.11.1509191350240.24753@minas-tirith.valinor>


El 2015-09-19 a las 02:30 +0200, Carlos E. R. escribió:

> There is no need to go to extreme measures; I think it is easier than
> that. I do not have access to the oss.sgi.com logs, but surely the admins
> can, and find out what were the posts that bounced and for what reason.
>
> My guess is that they were sent from an invalid domain (no dns), or no
> reverse dns, or something like that (not content analysis, that comes
> once the mail is accepted and stored). Surely a filter for those is simple
> enough to implement, and should not harm other participants.

Alternatively, don't automatically disable subscriptions that fast:

    Your membership in the mailing list xfs has been disabled due to
    excessive bounces The last bounce received from you was dated
    16-Sep-2015.  You will not get any more messages from this list until
    you re-enable your membership.  You will receive 3 more reminders like
    this before your membership in the list is deleted.

    To re-enable your membership, you can simply respond to this message
    (leaving the Subject: line intact), or visit the confirmation page at


THAT is the problem I'm having. The spam I get I can filter out, it is not 
that bad.

- -- 
Cheers
        Carlos E. R.

        (from 13.1 x86_64 "Bottle" (Minas Tirith))
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iF4EAREIAAYFAlX9THAACgkQja8UbcUWM1xZFQD/ZgcquQgQAhL6kAiJSgOfgvO4
/RyGTnY+lzHmj9b7wasA/3LYl6vpE3pcXXh2SJzaR2bgquCF8f+LJS7001m/wDlO
=0YzB
-----END PGP SIGNATURE-----
---1463758550-1134733686-1442663224=:24753
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

---1463758550-1134733686-1442663224=:24753--
