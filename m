Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 33B877F51
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 10:06:32 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 12005304077
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 08:06:28 -0800 (PST)
Received: from x.digitalelves.com (x.digitalelves.com [209.98.77.55]) by
	cuda.sgi.com with ESMTP id lOu1rmkKVJf5EK46 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Feb 2014 08:06:26 -0800 (PST)
Message-ID: <52F10FFF.8090009@thebarn.com>
Date: Tue, 04 Feb 2014 10:06:23 -0600
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: xfs.org wiki is down
References: <20140204081546.GB13997@dastard>
In-Reply-To: <20140204081546.GB13997@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6141083768707491392=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============6141083768707491392==
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="qVbqMgoonvv1MpRcPxHUJrEEvBQCf6vsD"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qVbqMgoonvv1MpRcPxHUJrEEvBQCf6vsD
Content-Type: multipart/mixed;
 boundary="------------080907030408000500080009"

This is a multi-part message in MIME format.
--------------080907030408000500080009
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2/4/14, 2:15 AM, Dave Chinner wrote:
> Hi Russell,
>=20
> I just went to look at the xfs.org wiki and all I get from xfs.org
> "not found" errors. e.g http://xfs.org/index.php/Main_Page gives:
>=20
>   Not Found
>=20
>   The requested URL /index.php/Main_Page was not found on this server.
Opps my bad -- I accidentally ended up replacing the a symlink with
directory.

I was staging some upgrades and rsync the tree over which ended up doing
the replace.

Sym link is restored.

-Russell

>=20
> So it looks like something has been broken in the past couple of
> hours. Any idea what has happened?
>=20
> Cheers,
>=20
> Dave.
>=20


--------------080907030408000500080009
Content-Type: text/x-vcard; charset=utf-8;
 name="cattelan.vcf"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="cattelan.vcf"

begin:vcard
fn:Russell Cattelan
n:Cattelan;Russell
org:Digital Elves Inc
adr:;;2824 Lakeview Ave;Roseville;MN;55113;usa
email;internet:cattelan@digitalelves.com
tel;work:612 293 6009
tel;cell:612 805 3144
x-mozilla-html:FALSE
url:http://digitalelves.com
version:2.1
end:vcard


--------------080907030408000500080009--

--qVbqMgoonvv1MpRcPxHUJrEEvBQCf6vsD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (Darwin)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iD8DBQFS8RADNRmM+OaGhBgRAvDvAJ9SoTpQ28G9seRz30u8aukEyzIFAwCgglKI
NEzhxkULHbM6kJBDQancOWg=
=bXQW
-----END PGP SIGNATURE-----

--qVbqMgoonvv1MpRcPxHUJrEEvBQCf6vsD--


--===============6141083768707491392==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6141083768707491392==--
