Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4A1977F4E
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 08:22:23 -0500 (CDT)
Message-ID: <51938C29.4010904@sgi.com>
Date: Wed, 15 May 2013 08:22:49 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: change file mode
References: <1368347826-32152-1-git-send-email-wenqing.lz@taobao.com>
In-Reply-To: <1368347826-32152-1-git-send-email-wenqing.lz@taobao.com>
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
To: Zheng Liu <gnehzuil.liu@gmail.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, xfs@oss.sgi.com

On 05/12/2013 03:37 AM, Zheng Liu wrote:
> Now in tests/ there are some test cases whose mode is 0644.  But they
> should be 0755.  So fix it.
>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
>
This patch has been committed:

commit fbf6e863ccb628ff5dd7407d58a065e5f264a7ab
Author: Zheng Liu <wenqing.lz@taobao.com>
Date:   Wed May 15 08:17:51 2013 -0500

     xfstests: change test case file mode to 0755

     Now in tests/ there are some test cases whose mode is 0644.  But they
     should be 0755.  So fix it.

     Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
     Reviewed-by: Dave Chinner <david@redhat.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>

Thanks
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
