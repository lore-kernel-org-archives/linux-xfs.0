Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 18CC67F4E
	for <xfs@oss.sgi.com>; Sun, 13 Jul 2014 09:54:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 067BE8F8039
	for <xfs@oss.sgi.com>; Sun, 13 Jul 2014 07:54:11 -0700 (PDT)
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15]) by cuda.sgi.com
	with ESMTP id NL9Td32B36yju9Ww (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 13 Jul 2014 07:54:10 -0700 (PDT)
MIME-Version: 1.0
Message-ID: <trinity-7b6278aa-77fd-4df3-a739-35bf36685aa5-1405263248667@3capp-gmx-bs57>
From: "Hans Kraus" <hans.w.kraus@gmx.at>
Subject: Re: Error (failing assert) in xfs_repair
Date: Sun, 13 Jul 2014 16:54:08 +0200
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
To: xfs@oss.sgi.com

Hi Dave,

thanks for the patch. It worked and I lost not very many files. The good thing with backuppc is,
that only deleted or corrupted files are copied anew, as a result of the file deduplication
(on file basis).

Thanks, Hans

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
