Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q91EiTs9134225 for <xfs@oss.sgi.com>; Mon, 1 Oct 2012 09:44:29 -0500
Received: from smtprelay06.ispgateway.de (smtprelay06.ispgateway.de
	[80.67.31.101]) by cuda.sgi.com with ESMTP id wAi1bxuogFkifSMQ
	for <xfs@oss.sgi.com>; Mon, 01 Oct 2012 07:45:51 -0700 (PDT)
Message-ID: <5069AC9D.4090907@cape-horn-eng.com>
Date: Mon, 01 Oct 2012 16:45:49 +0200
From: Richard Ems <richard.ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: Re: creating a new 80 TB XFS
References: <4F478818.4050803@cape-horn-eng.com> <4F47AA24.8010209@sandeen.net>
	<5069A8A1.4080404@cape-horn-eng.com> <5069AB05.3090901@sandeen.net>
In-Reply-To: <5069AB05.3090901@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On 10/01/2012 04:39 PM, Eric Sandeen wrote:
> you can use the xfs_bmap tool to map the attribute fork by using the "-a"=
 option.
> =

> If it lists any block numbers, then it's outside the inode.
> =

> If you have varying sizes of acls, you'd just iterate over the fs to see =
what you've got.

Ok, many thanks Eric!

cheers,
Richard


-- =

Richard Ems       mail: Richard.Ems@Cape-Horn-Eng.com

Cape Horn Engineering S.L.
C/ Dr. J.J. D=F3mine 1, 5=BA piso
46011 Valencia
Tel : +34 96 3242923 / Fax 924
http://www.cape-horn-eng.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
