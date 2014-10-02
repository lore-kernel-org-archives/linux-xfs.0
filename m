Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0AE8D7F56
	for <xfs@oss.sgi.com>; Thu,  2 Oct 2014 06:46:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CEC298F8037
	for <xfs@oss.sgi.com>; Thu,  2 Oct 2014 04:46:24 -0700 (PDT)
Received: from mail-wi0-f174.google.com (mail-wi0-f174.google.com
	[209.85.212.174]) by cuda.sgi.com with ESMTP id
	Yo4GhR7nYLAOTWbQ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 Oct 2014 04:46:23 -0700 (PDT)
Received: by mail-wi0-f174.google.com with SMTP id cc10so3646391wib.13
	for <xfs@oss.sgi.com>; Thu, 02 Oct 2014 04:46:21 -0700 (PDT)
Received: from Telcontar.valinor (177.Red-79-159-63.staticIP.rima-tde.net.
	[79.159.63.177])
	by mx.google.com with ESMTPSA id g6sm4341934wjf.13.2014.10.02.04.46.20
	for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Thu, 02 Oct 2014 04:46:21 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id ABE7A606A6
	for <xfs@oss.sgi.com>; Thu,  2 Oct 2014 13:46:18 +0200 (CEST)
Received: from Telcontar.valinor ([127.0.0.1])
	by localhost (Telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id JHHmRf7BExMK for <xfs@oss.sgi.com>;
	Thu,  2 Oct 2014 13:46:18 +0200 (CEST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id 8D5AF606A5
	for <xfs@oss.sgi.com>; Thu,  2 Oct 2014 13:46:18 +0200 (CEST)
Message-ID: <542D3B0A.5030600@opensuse.org>
Date: Thu, 02 Oct 2014 13:46:18 +0200
From: "Carlos E. R." <carlos.e.r@opensuse.org>
MIME-Version: 1.0
Subject: Re: Happened again,
	20140930 -- Got "Internal error XFS_WANT_CORRUPTED_GOTO".
	Filesystem needs reformatting to correct issue.
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>	<alpine.LSU.2.11.1408111559280.2447@minas-tirith.valinor>	<alpine.LSU.2.11.1410010001350.17407@minas-tirith.valinor>	<20141001004514.GH24490@dastard>
	<542B6B8A.2060309@opensuse.org>
	<20141002113205.GE19748@quack.suse.cz>
In-Reply-To: <20141002113205.GE19748@quack.suse.cz>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: XFS mailing list <xfs@oss.sgi.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2014-10-02 13:32, Jan Kara wrote:
> On Wed 01-10-14 04:48:42, Carlos E. R. wrote:


>> Question: where does it apply, kernel, xfsprogs? They will know,
>> but I don't, and I need that info for the bugzilla "component"
>> field ;-)
> Feel free to assign that bug to me (jack at suse.com in bugzilla)
> and I'll take care of it.

Sure, thanks.
I'm busy with other things right now, will do as soon as I can.
Yesterday I was restoring the machine.

- -- 
Cheers / Saludos,

		Carlos E. R.
		(from 13.1 x86_64 "Bottle" at Telcontar)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlQtOv8ACgkQtTMYHG2NR9Ux/QCdExQvegQEierd/9RiFwvjQ+6z
wBcAmgOdaaeWY3iZaTo4HogjuxqUSsMg
=8lRj
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
