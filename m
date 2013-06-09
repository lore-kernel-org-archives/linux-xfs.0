Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1DD2929DF8
	for <xfs@oss.sgi.com>; Sun,  9 Jun 2013 07:13:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0DAC1304032
	for <xfs@oss.sgi.com>; Sun,  9 Jun 2013 05:13:09 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 83oajnjIGAeoBw4k for
	<xfs@oss.sgi.com>; Sun, 09 Jun 2013 05:13:06 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r59CD5a3012342
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Sun, 9 Jun 2013 08:13:05 -0400
Received: from tunkums.home (ovpn-113-21.phx2.redhat.com [10.3.113.21])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r59CD4Jt015574
	for <xfs@oss.sgi.com>; Sun, 9 Jun 2013 08:13:05 -0400
Message-ID: <51B47150.6000500@redhat.com>
Date: Sun, 09 Jun 2013 08:13:04 -0400
From: Ric Wheeler <rwheeler@redhat.com>
MIME-Version: 1.0
Subject: Re: attack upon XFS, misinformation abounds, linux-raid list
References: <51B45CFD.20500@hardwarefreak.com>
In-Reply-To: <51B45CFD.20500@hardwarefreak.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 06/09/2013 06:46 AM, Stan Hoeppner wrote:
> In a recent linux-raid list thread here:
> http://marc.info/?l=linux-raid&m=137072140106867&w=2
>
> seriously flawed arguments against the reliability of XFS, and even the
> performance of XFS, are made.  The OP even quotes Dave's LCA
> presentation as a performance reason to avoid XFS.  The party really
> gets started at paragraph 7.
>
> I made a brief effort to debunk his claims and explained that he can't
> have O_PONIES, that he should use fsync or O_DIRECT, etc for data
> safety.  To non experts/advanced filesystem users, his long winded
> argument may be persuasive.  Obviously none of you experts has time to
> debunk every such post, but this one may be worth a read at least,
> especially given the weight Google gives to vger lists.

Thanks for pointing that out - I responded as well.

Funny that he decided to use ext4 after basing it on a google search for "xfs 
zero" and did not bother to the same query with "ext4 zero length files" :)

Ric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
