Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p04LoaTW046291 for <xfs@oss.sgi.com>; Tue, 4 Jan 2011 15:50:36 -0600
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0C1FF1D0C6D8
	for <xfs@oss.sgi.com>; Tue,  4 Jan 2011 13:52:42 -0800 (PST)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id 6TwX8drZo8zJsBg1 for
	<xfs@oss.sgi.com>; Tue, 04 Jan 2011 13:52:42 -0800 (PST)
Date: Tue, 4 Jan 2011 22:52:29 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Simultaneously mounting one XFS partition on multiple machines
Message-ID: <20110104225229.6aa47710@galadriel.home>
In-Reply-To: <AANLkTi=B_zhQG9P22gXcb40JZT=VnEUedTW9xxcuN4cP@mail.gmail.com>
References: <AANLkTi=B_zhQG9P22gXcb40JZT=VnEUedTW9xxcuN4cP@mail.gmail.com>
Mime-Version: 1.0
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
To: "Patrick J. LoPresti" <lopresti@gmail.com>
Cc: xfs@oss.sgi.com

Le Tue, 4 Jan 2011 09:46:39 -0800 vous =E9criviez:

> If your answer is "Please do not do this; get a clustered filesystem",
> then trust me, you are preaching to the choir. =


Just as a side note : OCFS2 works well, is present in all major
distros, is extremely fast to setup and install, and is only slightly
slower than xfs. There is absolutely no valid reason not to use it (GFS
OTOH is a complete PITA to setup).

Yeah I know, I know...
-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
