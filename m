Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9VEIdlq078418 for <xfs@oss.sgi.com>; Sat, 31 Oct 2009 09:18:39 -0500
Received: from smtp5-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0FD3D4F9B2
	for <xfs@oss.sgi.com>; Sat, 31 Oct 2009 07:18:49 -0700 (PDT)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id rihN5TQagwFRzNL0 for
	<xfs@oss.sgi.com>; Sat, 31 Oct 2009 07:18:49 -0700 (PDT)
Date: Sat, 31 Oct 2009 15:18:25 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS and DPX files
Message-ID: <20091031151825.46210b6a@galadriel.home>
In-Reply-To: <4AEC2CF4.8040703@aol.com>
References: <4AEC2CF4.8040703@aol.com>
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
Cc: xfs@oss.sgi.com

Le Sat, 31 Oct 2009 08:26:28 -0400 vous =E9criviez:

> Any ideas here? Is this a known issue? And is there a workaround? Any =

> help would be greatly appreciated.

Maybe  you should try mounting the XFS filesystem with these options :
nobarrier,noatime

-- =

--------------------------------------------------
Emmanuel Florac               www.intellique.com   =

--------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
