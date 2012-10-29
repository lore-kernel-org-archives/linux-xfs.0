Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9T8FQTv145005 for <xfs@oss.sgi.com>; Mon, 29 Oct 2012 03:15:26 -0500
Received: from smtp-tls.univ-nantes.fr (smtptls1-loi.cpub.univ-nantes.fr
	[193.52.103.112]) by cuda.sgi.com with ESMTP id
	5V0BqCiH45pPDeox for <xfs@oss.sgi.com>;
	Mon, 29 Oct 2012 01:17:14 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by smtp-tls.univ-nantes.fr (Postfix) with ESMTP id 198E24016E4
	for <xfs@oss.sgi.com>; Mon, 29 Oct 2012 09:17:14 +0100 (CET)
Received: from smtp-tls.univ-nantes.fr ([127.0.0.1])
	by localhost (smtptls1-loi.cpub.univ-nantes.fr [127.0.0.1])
	(amavisd-new, port 10024)
	with LMTP id 7Tjl2+we4sSq for <xfs@oss.sgi.com>;
	Mon, 29 Oct 2012 09:17:14 +0100 (CET)
Received: from [IPv6:2001:660:7220:0:1cf5:475e:2845:4f5e] (unknown
	[IPv6:2001:660:7220:0:1cf5:475e:2845:4f5e])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp-tls.univ-nantes.fr (Postfix) with ESMTPSA id DFCE24016E0
	for <xfs@oss.sgi.com>; Mon, 29 Oct 2012 09:17:13 +0100 (CET)
Message-ID: <508E3B89.2070004@univ-nantes.fr>
Date: Mon, 29 Oct 2012 09:17:13 +0100
From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
MIME-Version: 1.0
Subject: Re: Problems with kernel 3.6.x (vm ?) (was : Is kernel 3.6.1 or
	filestreams option toxic ?)
References: <508554AF.5050005@univ-nantes.fr> <50865453.5080708@univ-nantes.fr>
	<508958FF.4000007@univ-nantes.fr> <20121025211047.GD29378@dastard>
	<508A600C.1020109@univ-nantes.fr> <508B092E.6070209@univ-nantes.fr>
	<20121028234802.GE4353@dastard> <508E3940.4080200@univ-nantes.fr>
In-Reply-To: <508E3940.4080200@univ-nantes.fr>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Le 29/10/2012 09:07, Yann Dupont a =E9crit :
>
> Hello dave. That is THE question. My intent was to test with and =

> without LVM. But right now I can't , because all my disks are consumed =

> by lvm.
> In fact my test setup hasn't even enough space to locally clone the =

> volume where I have errors. I only have 146 sas disks on this machine.
whoooops
read 146 GB sas disks

If I really had 146 sas disks on that machine I shouldn't have disk =

space problems :)
Cheers,

-- =

Yann Dupont - Service IRTS, DSI Universit=E9 de Nantes
Tel : 02.53.48.49.20 - Mail/Jabber : Yann.Dupont@univ-nantes.fr

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
