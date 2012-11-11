Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAB76NOJ098200 for <xfs@oss.sgi.com>; Sun, 11 Nov 2012 01:06:23 -0600
Received: from mail-vb0-f53.google.com (mail-vb0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id fhGUpxkZc6asyKQw
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 10 Nov 2012 23:08:24 -0800 (PST)
Received: by mail-vb0-f53.google.com with SMTP id fc21so5550101vbb.26
	for <xfs@oss.sgi.com>; Sat, 10 Nov 2012 23:08:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABJyUzJVj-rpGW=i5QG=AZPvhuD-qdbujuwOdu_EdGbYGZ++Rg@mail.gmail.com>
References: <CABJyUz+h=pZ6+2rro1PjoB1ggTAoRw+bTzc_bU7Eaec0_AUKLA@mail.gmail.com>
	<20121101225938.GS29378@dastard>
	<CABJyUz+VhUY=tVKpEeKXfQRoaL4s+gwNmRr4wNAnRX6zTt5xXg@mail.gmail.com>
	<CABJyUz+r7yQSswqyBng_W=fAXxTz9heb88NeiKSeFU7j4ZD=Hw@mail.gmail.com>
	<20121108210210.GP6434@dastard>
	<CABJyUzKy4YXVZAj=awVNfPD69eWo2mKhM7a-xWF1Vy-PD989sg@mail.gmail.com>
	<20121109104839.GE6434@dastard>
	<CABJyUzJVj-rpGW=i5QG=AZPvhuD-qdbujuwOdu_EdGbYGZ++Rg@mail.gmail.com>
Date: Sat, 10 Nov 2012 23:08:23 -0800
Message-ID: <CABJyUzJ7maOcj+aPkpCvBc1-P+Z-XPsft8rbsVnqgpfyVCs9xQ@mail.gmail.com>
Subject: Re: XFS filesystem recovery from secondary superblocks
From: Aaron Goulding <aarongldng@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0764673018021863146=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============0764673018021863146==
Content-Type: multipart/alternative; boundary=bcaec54a377ab94fbd04ce32d9ed

--bcaec54a377ab94fbd04ce32d9ed
Content-Type: text/plain; charset=ISO-8859-1

As I guessed, xfs_repair didn't work. xfs_db does now load with warnings,
but I fear I don't know enough about that to properly use that tool. I've
done a search for xfs_irepair but I'm finding very little from that. Where
is that tool located? I'm understanding a full restore is very unlikely at
this point, but if I can get anything, I'll consider this project a success
and a learning experience. :)

-Aaron

--bcaec54a377ab94fbd04ce32d9ed
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

As I guessed, xfs_repair didn&#39;t work. xfs_db does now load with warning=
s, but I fear I don&#39;t know enough about that to properly use that tool.=
 I&#39;ve done a search for xfs_irepair but I&#39;m finding very little fro=
m that. Where is that tool located? I&#39;m understanding a full restore is=
 very unlikely at this point, but if I can get anything, I&#39;ll consider =
this project a success and a learning experience. :)<br>
<br>-Aaron<br>

--bcaec54a377ab94fbd04ce32d9ed--


--===============0764673018021863146==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0764673018021863146==--
