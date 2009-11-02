Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA2MQJL0097925 for <xfs@oss.sgi.com>; Mon, 2 Nov 2009 16:26:19 -0600
Received: from smtp5-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E231014D0C4B
	for <xfs@oss.sgi.com>; Mon,  2 Nov 2009 14:26:29 -0800 (PST)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id VF4JFiV50zDAywOU for
	<xfs@oss.sgi.com>; Mon, 02 Nov 2009 14:26:29 -0800 (PST)
Date: Mon, 2 Nov 2009 23:26:11 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS and DPX files
Message-ID: <20091102232611.6da5c44f@galadriel.home>
In-Reply-To: <4AEF5438.5050801@aol.com>
References: <4AEC2CF4.8040703@aol.com> <4AEC4BAA.20606@aol.com>
	<20091031174836.3fc9505b@galadriel.home>
	<200911021205.28006@zmi.at>
	<20091102185249.0da8e388@harpe.intellique.com>
	<4AEF5438.5050801@aol.com>
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
To: "AndrewL733@aol.com" <AndrewL733@aol.com>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

Le Mon, 02 Nov 2009 16:50:48 -0500 vous =E9criviez:

> It seems as if some resource that =

> XFS needs is being used up after a certain number of files are
> created, and that it is very disruptive and costly to get more of
> that resource. Why ext3 and ext4 can keep going past 60,000 files and
> xfs falls over after 4000 or 5000 files, I do not understand.

I'll do some checks on my side, I have several RAID systems with
various RAID controllers (including 3Ware) and a nice "dpx stream"
simulator from OPenCube.

-- =

--------------------------------------------------
Emmanuel Florac               www.intellique.com   =

--------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
