Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9B6947F3F
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 15:29:21 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7BF5F304051
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 13:29:18 -0800 (PST)
Received: from mail-we0-f196.google.com (mail-we0-f196.google.com
	[74.125.82.196]) by cuda.sgi.com with ESMTP id opuzaV7qHnHz7xl2
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 08 Jan 2015 13:29:01 -0800 (PST)
Received: by mail-we0-f196.google.com with SMTP id k48so1457283wev.3
	for <xfs@oss.sgi.com>; Thu, 08 Jan 2015 13:29:00 -0800 (PST)
Received: from Telcontar.valinor (33.Red-83-34-5.dynamicIP.rima-tde.net.
	[83.34.5.33])
	by mx.google.com with ESMTPSA id ej10sm8094286wib.2.2015.01.08.13.28.58
	for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Thu, 08 Jan 2015 13:28:58 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id A1D70604CA
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 22:28:55 +0100 (CET)
Received: from Telcontar.valinor ([127.0.0.1])
	by localhost (Telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id K_DVcvPD-7Z9 for <xfs@oss.sgi.com>;
	Thu,  8 Jan 2015 22:28:54 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id 5D8BF603CE
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 22:28:53 +0100 (CET)
Date: Thu, 8 Jan 2015 22:28:52 +0100 (CET)
From: "Carlos E. R." <carlos.e.r@opensuse.org>
Subject: About XFS size in 32/64 bit Linux
Message-ID: <alpine.LSU.2.11.1501082223080.5948@Telcontar.valinor>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: XFS mailing list <xfs@oss.sgi.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



Hi,

I'm about to prepare an XFS partitioned 2TB hard disk in an external 
enclosure (USB/eSATA), using openSUSE 13.1 64 bit, but I intend to use it 
mostly under 13.1 32 bit (kernel 3.11.10)

Should I expect problems? Something to be aware of? Limits when using 32 
bit, perhaps?

- -- 
Cheers,
        Carlos E. R.
        (from openSUSE 13.1 x86_64 "Bottle" at Telcontar)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlSu9pUACgkQtTMYHG2NR9VwZQCfcy2Q6fVYLVnsMjrsjdYplLnw
TtQAn1MWvkwwcrUBQp0+18dJA+DjP08o
=wGL7
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
