Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7B83GgZ127682 for <xfs@oss.sgi.com>; Wed, 11 Aug 2010 03:03:17 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ECE624AA543
	for <xfs@oss.sgi.com>; Wed, 11 Aug 2010 01:03:39 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id hTBJsTELWYftOvkQ for
	<xfs@oss.sgi.com>; Wed, 11 Aug 2010 01:03:39 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id A2BB817E
	for <xfs@oss.sgi.com>; Wed, 11 Aug 2010 10:03:37 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 65BCC47EA07
	for <xfs@oss.sgi.com>; Wed, 11 Aug 2010 10:03:37 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: observed significant performance improvement using "delaylog" in
	a real-world application
Date: Wed, 11 Aug 2010 10:03:36 +0200
References: <i3rt4t$46c$1@dough.gmane.org>
In-Reply-To: <i3rt4t$46c$1@dough.gmane.org>
MIME-Version: 1.0
Message-Id: <201008111003.36890@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3491836863207728999=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3491836863207728999==
Content-Type: multipart/signed;
  boundary="nextPart4825992.PizCbbSebK";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart4825992.PizCbbSebK
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 10. August 2010 Peter Niemayer wrote:
> 17% performance increase for our benchmark scenario
=20
Can you say what kind of data accesses you have? Database, fileserver,=20
virtualization platform with VM Images on XFS... there are so many. Just=20
to get an idea in which area delaylog helps that much.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Aktuelles Radiointerview! ******
http://www.it-podcast.at/aktuelle-sendung.html

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart4825992.PizCbbSebK
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkxiWVgACgkQzhSR9xwSCbRSvwCg1ptWeG8Xp8Pq3WubbZZJdd/X
troAoLVnTNZW4yaHvK008SDL/bL4aKdV
=BDCK
-----END PGP SIGNATURE-----

--nextPart4825992.PizCbbSebK--


--===============3491836863207728999==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3491836863207728999==--
