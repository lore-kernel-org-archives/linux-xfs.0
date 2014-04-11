Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1670C29DF7
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 14:02:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A096FAC002
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 12:02:46 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id WYi9Aa97FGycW6eF for
	<xfs@oss.sgi.com>; Fri, 11 Apr 2014 12:02:45 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3BJ2jO6032218
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 15:02:45 -0400
Date: Fri, 11 Apr 2014 15:02:31 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 00/14] xfsprogs: varius & sundry fixes for coverity defects
Message-ID: <20140411190231.GA16717@laptop.bfoster>
References: <1396999504-13769-1-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1396999504-13769-1-git-send-email-sandeen@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Apr 08, 2014 at 06:24:50PM -0500, Eric Sandeen wrote:
> This series knocks out 30 or so coverity defects.
> 

Noted a few nits... things that could probably be fixed up at commit
time if so desired. Otherwise, the series looks good to me. Thanks Eric.

Reviewed-by: Brian Foster <bfoster@redhat.com>

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
