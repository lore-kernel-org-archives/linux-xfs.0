Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 07C967F37
	for <xfs@oss.sgi.com>; Mon, 21 Sep 2015 12:36:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CBB2F304067
	for <xfs@oss.sgi.com>; Mon, 21 Sep 2015 10:36:26 -0700 (PDT)
Received: from mail-wi0-f170.google.com (mail-wi0-f170.google.com
	[209.85.212.170]) by cuda.sgi.com with ESMTP id
	pLLaBtRsn88b6x1P (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 21 Sep 2015 10:36:22 -0700 (PDT)
Received: by wicfx3 with SMTP id fx3so122254416wic.0
	for <xfs@oss.sgi.com>; Mon, 21 Sep 2015 10:36:20 -0700 (PDT)
Received: from minas-tirith.valinor (118.Red-176-80-72.dynamicIP.rima-tde.net.
	[176.80.72.118])
	by smtp.gmail.com with ESMTPSA id e6sm9178635wiy.3.2015.09.21.10.36.17
	for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Mon, 21 Sep 2015 10:36:20 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by minas-tirith.valinor (Postfix) with ESMTP id 987EA181FEC
	for <xfs@oss.sgi.com>; Mon, 21 Sep 2015 19:36:10 +0200 (CEST)
Date: Mon, 21 Sep 2015 19:36:10 +0200 (CEST)
From: "Carlos E. R." <carlos.e.r@opensuse.org>
Subject: Re: What's up with this list?
In-Reply-To: <56001EB2.2000109@sgi.com>
Message-ID: <alpine.LSU.2.11.1509211917480.24753@minas-tirith.valinor>
References: <alpine.LSU.2.11.1409181438290.6675@Telcontar.valinor>
	<541AFB60.5030403@sgi.com>
	<alpine.LSU.2.11.1509161436390.25528@minas-tirith.valinor>
	<55FAF053.3020405@sgi.com> <55FB06E8.1020203@opensuse.org>
	<55FC3569.5020801@sgi.com> <20150918225624.GF26895@dastard>
	<56001EB2.2000109@sgi.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-1463758550-1715253016-1442856172=:24753"
Content-ID: <alpine.LSU.2.11.1509211931150.24753@minas-tirith.valinor>
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

---1463758550-1715253016-1442856172=:24753
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LSU.2.11.1509211923521.24753@minas-tirith.valinor>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Content-ID: <alpine.LSU.2.11.1509211931150.24753@minas-tirith.valinor>


El 2015-09-21 a las 10:13 -0500, Troy McCorkell escribió:

> I understand moderation is not an option.   Just reviewing the options.
>
> oss.sgi.com is not a stand alone system when it comes to email.  All 
> emails received by oss.sgi.com first pass through the SGI corporate spam 
> filters.  Several of the old defunct mailing lists on oss.sgi.com have 
> been configured as spam-traps. Additional spam filters have been added 
> specifically for oss.sgi.com. And yet spam continues to hit the list.
>
> I'll continue the conversation with the SGI IT group.


At opensuse mail lists they tried for a year or two opening some mail 
lists, so that subscription was not required for posting, on some of the 
lists. The ammount of spam increased. Aparently all measures they tried 
failed, and they eventually went back to the old system or requring 
registration previous to emailing.

Curtailing that amount of spam would take aggresive filtering, so agresive 
as to make difficult for normal people to post.


However, most of that spam was filtered out at my inbox. Ocassionally, a 
post would bounce at my ISP, yes, same as here. But I never got 
unsuscribed. Instead, I get probing posts like this:

+++-.-.-.-.-.-.-.-.-.
Subject:  Bouncing messages from opensuse@opensuse.org

Hi, this is the Mlmmj program managing the <opensuse at opensuse.org> 
mailing list.

Some messages to you could not be delivered. If you're seeing this
message it means things are back to normal, and it's merely for your
information.

Here is the list of the bounced messages:
- - 176321
- - 176324
- - 176323
- - 176320
- -.-.-.-.-.-.-.-.-.++-

If I try to retrieve one of those failed posts, get it resent, it never 
arrives. Apparently it bounces again. Sometimes I'm able to locate it at 
the web mail archive, and it is certainly spam, with an invalid "from:" or 
similar issue.


The problem, for me, is that sgi.com's Mailman doesn't probe. Instead, it 
shooes me out inmediately if one post can not be sent. Aparently it does 
not consider that other posts are sent without problem, nor sends a probe.

That's the problem that concerns me: that my subscription is deactivated 
on bounces. And it is the only mail list that I'm subscribed to where this 
happens, as far as I remember.


- -- 
Cheers
        Carlos E. R.

        (from 13.1 x86_64 "Bottle" (Minas Tirith))
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iF4EAREIAAYFAlYAQAoACgkQja8UbcUWM1yarQD9FKvr6pmjvKd23Cuc/eJY9u88
2szq7MAbEtica4AcYDkA/375dewwBfik89iOwWeeQIZnk7FBFPrT9VsJ00FOgAL9
=Z0Ro
-----END PGP SIGNATURE-----
---1463758550-1715253016-1442856172=:24753
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

---1463758550-1715253016-1442856172=:24753--
