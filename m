Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B72C57F3F
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 05:31:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A22B08F8035
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 03:31:23 -0700 (PDT)
Received: from mail-we0-f175.google.com (mail-we0-f175.google.com
	[74.125.82.175]) by cuda.sgi.com with ESMTP id z8y1smWrnoAYkPmk
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 18 Aug 2014 03:31:22 -0700 (PDT)
Received: by mail-we0-f175.google.com with SMTP id t60so4789564wes.20
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 03:31:21 -0700 (PDT)
Received: from Telcontar.valinor (177.Red-79-159-63.staticIP.rima-tde.net.
	[79.159.63.177])
	by mx.google.com with ESMTPSA id a4sm36536700wie.21.2014.08.18.03.31.19
	for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Mon, 18 Aug 2014 03:31:20 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id 5844860E5A
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 12:31:18 +0200 (CEST)
Received: from Telcontar.valinor ([127.0.0.1])
	by localhost (Telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id PLIOvkKKjOsp for <xfs@oss.sgi.com>;
	Mon, 18 Aug 2014 12:31:18 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id 327E8605B8
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 12:31:18 +0200 (CEST)
Date: Mon, 18 Aug 2014 12:31:18 +0200 (CEST)
From: "Carlos E. R." <carlos.e.r@opensuse.org>
Subject: Re: Help setting up XFS
In-Reply-To: <BLU181-W306A7E4DE2F035EA4530139CD70@phx.gbl>
Message-ID: <alpine.LSU.2.11.1408181227030.5417@Telcontar.valinor>
References: <BLU181-W306A7E4DE2F035EA4530139CD70@phx.gbl>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-1463808511-487602297-1408357878=:5417"
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

---1463808511-487602297-1408357878=:5417
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



On Sunday, 2014-08-17 at 07:36 +0530, Prithvi Rathore wrote:

> Hi,
>     I am a student currently pursuing my under-graduation and would love to use XFS. I believe it has a lot to offer and I Iook forwarding to
> testing and using it on an external device like a pen-drive (USB) for starters.
>     I was a bit confused on how to set up XFS. I am currently using Ubuntu 14.04 dual boot (via rEFInd) with Mac OS X on MacBook Air 2013. 


I don't know about Ubuntu. In openSUSE I just open the graphical tool to 
format any device and format it, just selecting in the drop list XFS or 
any other type I want. On other distributions I would use gparted.

The procedure is exactly the same for any filesystem you choose.

I rather think that what you need is help on using Linux, not XFS.

- -- 
Cheers,
        Carlos E. R.
        (from 13.1 x86_64 "Bottle" at Telcontar)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlPx1fYACgkQtTMYHG2NR9X0PQCeLq7Q5/uEOzxtiAhdY4QlZjb5
cHAAn0w7eXWilM+IVH852cLmg076zEYv
=cMGX
-----END PGP SIGNATURE-----
---1463808511-487602297-1408357878=:5417
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

---1463808511-487602297-1408357878=:5417--
