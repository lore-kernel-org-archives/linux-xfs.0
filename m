Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 05B177F37
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 17:16:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D3F82304066
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 15:16:49 -0700 (PDT)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id f8xN2aYBmPAjSnX6 for
	<xfs@oss.sgi.com>; Fri, 14 Jun 2013 15:16:48 -0700 (PDT)
Date: Fri, 14 Jun 2013 18:16:47 -0400 (EDT)
From: Nathan Scott <nathans@redhat.com>
Message-ID: <91017249.1356192.1371248207334.JavaMail.root@redhat.com>
In-Reply-To: <CAC2B=ZFP_Fg34aFpk857stgB7MGcrYs9tybRS-ttw1CXNeU41Q@mail.gmail.com>
References: <CAC2B=ZFP_Fg34aFpk857stgB7MGcrYs9tybRS-ttw1CXNeU41Q@mail.gmail.com>
Subject: Re: definitions for /proc/fs/xfs/stat
MIME-Version: 1.0
Reply-To: Nathan Scott <nathans@redhat.com>
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
To: Mark Seger <mjseger@gmail.com>
Cc: xfs@oss.sgi.com

Hi Mark,

----- Original Message -----
> I've been thinking about adding xfs support to collectl but am having a hard
> time trying to decode he data in the stat file. can someone point me to a
> decoder ring? thanks.

Using Performance Co-Pilot, "pminfo -T xfs" will give you the answers you seek.
[ http://oss.sgi.com/projects/pcp/ ]

cheers.

--
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
