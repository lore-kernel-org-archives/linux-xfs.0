Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4FF5C7F74
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 12:58:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3BBEC304051
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 10:58:56 -0700 (PDT)
Received: from vz1.blur.com (vz1.blur.com [67.228.122.164]) by cuda.sgi.com
	with ESMTP id uA7tKAXa7C7D7zTG (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 30 Jul 2014 10:58:54 -0700 (PDT)
Message-ID: <53D93246.1070406@blur.com>
Date: Wed, 30 Jul 2014 10:58:30 -0700
From: Duane Powell <duane@blur.com>
MIME-Version: 1.0
Subject: xfs_metadump from Blur Studio
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

XFS!,

corrupt dinode 1124573, extent total = 1, nblocks = 0.  This is a bug.
Please capture the filesystem metadata with xfs_metadump and
report it to xfs@oss.sgi.com.

dump to big to email, please use this ftp account.

ftp.blur.com
user: xsi
password: smoke.water.775

./pickup/xfs.bug.dump

Thanks,
Duane

PS
Some samples of what were creating on xfs filers

http://vimeo.com/97143634
http://www.reddit.com/r/videos/comments/2be22a/league_of_legends_cinematic_a_new_dawn/


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
