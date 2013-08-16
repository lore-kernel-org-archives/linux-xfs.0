Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DD75C7F5F
	for <xfs@oss.sgi.com>; Fri, 16 Aug 2013 10:42:42 -0500 (CDT)
Message-ID: <520E489C.3090704@sgi.com>
Date: Fri, 16 Aug 2013 10:43:24 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [RFC][PATCH 00/10 v2] xfstests: Add support for config section
References: <1373539085-8577-1-git-send-email-lczerner@redhat.com>
In-Reply-To: <1373539085-8577-1-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, xfs@oss.sgi.com

Hey Lukas thanks for the patchset,

I have committed the reviewed patches 2, 4, 5 and 6.
Patches 3 and 10 have also been reviewed by Chandra but no longer apply 
cleanly to the current tree.
The other patches 1, 7, 8 and 9 are waiting your response to Chandras 
comments.

Thanks again
--Rich

commit c8527d1c8a90fc0dcb0c8edfc8ddf4c19267bd64
Author: Lukas Czerner <lczerner@redhat.com>
Date:   Thu Jul 11 10:37:57 2013 +0000

     xfstests: Export all important variables in common/config

commit 2ff460998d3c548da9c29c2a52a7f419a309a154
Author: Lukas Czerner <lczerner@redhat.com>
Date:   Thu Jul 11 10:37:59 2013 +0000

     xfstests: Allow to recheck options in common/rc

commit dcaf8661876c438f31eda196232d950f65648e96
Author: Lukas Czerner <lczerner@redhat.com>
Date:   Thu Jul 11 10:38:00 2013 +0000

     xfstests: Allow to re-read configuration

commit 9fe92ade36a71322e15fc1a57a3edc4a94c6d2c4
Author: Lukas Czerner <lczerner@redhat.com>
Date:   Thu Jul 11 10:38:01 2013 +0000

     xfstests: Allow to specify RESULT_BASE directory

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
