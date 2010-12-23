Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBNJRRL5231393 for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 13:27:27 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 95F251CF5273
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 11:29:26 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id Eb9gdCCkrQOL0pym for
	<xfs@oss.sgi.com>; Thu, 23 Dec 2010 11:29:26 -0800 (PST)
Date: Thu, 23 Dec 2010 14:29:26 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Anyone using XFS in production on > 20TiB volumes?
In-Reply-To: <20101223195544.53d45f0b@galadriel.home>
Message-ID: <alpine.DEB.2.00.1012231427430.6569@p34.internal.lan>
References: <alpine.DEB.2.00.1012221128440.5245@p34.internal.lan>
	<20101222175611.1c7d5190@harpe.intellique.com>
	<4D124B71.9030401@sandeen.net>
	<20101223012655.2681c596@galadriel.home>
	<alpine.DEB.2.00.1012221928050.7452@p34.internal.lan>
	<20101223005630.GJ4907@dastard>
	<alpine.DEB.2.00.1012230442150.7452@p34.internal.lan>
	<alpine.DEB.2.00.1012231304130.12482@p34.internal.lan>
	<20101223195544.53d45f0b@galadriel.home>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="655872-795982373-1293132566=:6569"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--655872-795982373-1293132566=:6569
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 23 Dec 2010, Emmanuel Florac wrote:

> Le Thu, 23 Dec 2010 13:06:10 -0500 (EST) vous =E9criviez:
>
>> http://home.comcast.net/~jpiszcz/20101223/final.html
>>

Please check the updated page:
http://home.comcast.net/~jpiszcz/20101223/final.html

Using a partition shows a slight degredation in the re-write speed but
an increase in performance for sequential output and input with the mode
set to perform.  Looks like this is what I will be using as it is the faste=
st
speeds overall except for the rewrite.

Thanks!

Justin.

--655872-795982373-1293132566=:6569
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--655872-795982373-1293132566=:6569--
