Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 16F767F56
	for <xfs@oss.sgi.com>; Fri, 18 Apr 2014 05:52:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BF209AC001
	for <xfs@oss.sgi.com>; Fri, 18 Apr 2014 03:52:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CxW8f7076SX58uvu for
	<xfs@oss.sgi.com>; Fri, 18 Apr 2014 03:52:37 -0700 (PDT)
Date: Fri, 18 Apr 2014 12:52:32 +0200
From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH v2] util-linux/fallocate: introduce an option -c to
	support COLLAPSE_RANGE
Message-ID: <20140418105232.GJ5786@x2.net.home>
References: <CAKYAXd-ngheH2njza1Tq0umONrF+VBrmB+9SiVG1Q=DsM0PBBA@mail.gmail.com>
	<1393497307-9205-1-git-send-email-dongsu.park@profitbricks.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1393497307-9205-1-git-send-email-dongsu.park@profitbricks.com>
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
To: Dongsu Park <dongsu.park@profitbricks.com>
Cc: Namjae Jeon <linkinjeon@gmail.com>, tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, xfs@oss.sgi.com, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org

On Thu, Feb 27, 2014 at 11:35:07AM +0100, Dongsu Park wrote:
>  sys-utils/fallocate.1 |  7 +++++++
>  sys-utils/fallocate.c | 45 ++++++++++++++++++++++++++++-----------------
>  2 files changed, 35 insertions(+), 17 deletions(-)

 Applied, thanks.

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
