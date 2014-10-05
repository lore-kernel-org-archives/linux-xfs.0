Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B67BA7F4E
	for <xfs@oss.sgi.com>; Sun,  5 Oct 2014 09:28:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 45052AC003
	for <xfs@oss.sgi.com>; Sun,  5 Oct 2014 07:28:35 -0700 (PDT)
Received: from mail-wi0-f180.google.com (mail-wi0-f180.google.com
	[209.85.212.180]) by cuda.sgi.com with ESMTP id
	3IK66eHIFPn39oss (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 05 Oct 2014 07:28:16 -0700 (PDT)
Received: by mail-wi0-f180.google.com with SMTP id em10so2453142wid.7
	for <xfs@oss.sgi.com>; Sun, 05 Oct 2014 07:28:15 -0700 (PDT)
Received: from Telcontar.valinor (177.Red-79-159-63.staticIP.rima-tde.net.
	[79.159.63.177]) by mx.google.com with ESMTPSA id
	wk5sm14100348wjb.12.2014.10.05.07.28.14 for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Sun, 05 Oct 2014 07:28:15 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id 1C23861343
	for <xfs@oss.sgi.com>; Sun,  5 Oct 2014 16:28:12 +0200 (CEST)
Received: from Telcontar.valinor ([127.0.0.1])
	by localhost (Telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id q1D628mXEetL for <xfs@oss.sgi.com>;
	Sun,  5 Oct 2014 16:28:12 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id D88BC60695
	for <xfs@oss.sgi.com>; Sun,  5 Oct 2014 16:28:11 +0200 (CEST)
Date: Sun, 5 Oct 2014 16:28:11 +0200 (CEST)
From: "Carlos E. R." <carlos.e.r@opensuse.org>
Subject: Re: Happened again,
	20140930 -- Got "Internal error XFS_WANT_CORRUPTED_GOTO".
	Filesystem needs reformatting to correct issue.
In-Reply-To: <542D3B0A.5030600@opensuse.org>
Message-ID: <alpine.LSU.2.11.1410051625480.6367@Telcontar.valinor>
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
	<alpine.LSU.2.11.1408111559280.2447@minas-tirith.valinor>
	<alpine.LSU.2.11.1410010001350.17407@minas-tirith.valinor>
	<20141001004514.GH24490@dastard> <542B6B8A.2060309@opensuse.org>
	<20141002113205.GE19748@quack.suse.cz> <542D3B0A.5030600@opensuse.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463808511-63611936-1412519291=:6367"
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

---1463808511-63611936-1412519291=:6367
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



On Thursday, 2014-10-02 at 13:46 +0200, Carlos E. R. wrote:
> On 2014-10-02 13:32, Jan Kara wrote:

>> Feel free to assign that bug to me (jack at suse.com in bugzilla)
>> and I'll take care of it.
>
> Sure, thanks.
> I'm busy with other things right now, will do as soon as I can.
> Yesterday I was restoring the machine.

Done!

Bugzilla – Bug 899785

at bugzilla.opensuse.org

Thanks all!

- -- 
Cheers,
        Carlos E. R.
        (from 13.1 x86_64 "Bottle" at Telcontar)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlQxVXsACgkQtTMYHG2NR9UrFwCfTGyKIbUE61zU/ypyyCp1f9IR
US0AnRaXbFjR35nW44sCUgYJF2JZq4Hn
=dkv8
-----END PGP SIGNATURE-----
---1463808511-63611936-1412519291=:6367
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

---1463808511-63611936-1412519291=:6367--
