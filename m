Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 37A1B29DF8
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 08:52:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 09BDE304053
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 06:52:38 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id IogfV7rZQD9dBN0Z for
	<xfs@oss.sgi.com>; Tue, 11 Jun 2013 06:52:38 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r5BDqbnu027684
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 09:52:37 -0400
Received: from tunkums.home (ovpn-113-106.phx2.redhat.com [10.3.113.106])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r5BDqbqT025451
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 09:52:37 -0400
Message-ID: <51B72BA4.6030701@redhat.com>
Date: Tue, 11 Jun 2013 09:52:36 -0400
From: Ric Wheeler <rwheeler@redhat.com>
MIME-Version: 1.0
Subject: Re: Questions about XFS
References: <loom.20130611T112155-970@post.gmane.org>
In-Reply-To: <loom.20130611T112155-970@post.gmane.org>
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

On 06/11/2013 05:56 AM, Steve Bergman wrote:
> 3. Why doesn't RHEL6 support XFS on root, when the XFS FAQ says XFS on root
> is fine? Is there some issue I should be aware of?

This is a vendor specific issue, not an upstream one, so let me put on my fedora 
and respond.

When Red Hat added XFS support several years back, we decided to roll it out in 
a very controlled way. Not a comment on any limitation on XFS as root.

Note that in RHEL7, we will be supporting XFS without this restriction.

Thanks!

Ric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
