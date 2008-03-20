Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Mar 2008 20:32:19 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2K3WBfF021611
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 20:32:12 -0700
Received: from p02c11o141.mxlogic.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F33926C3ECB
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 20:32:44 -0700 (PDT)
Received: from p02c11o141.mxlogic.net (p02c11o141.mxlogic.net [208.65.144.74]) by cuda.sgi.com with ESMTP id 4krChsGSzFWit4cv for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 20:32:44 -0700 (PDT)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Subject: RE: Duplicate directory entries
Date: Wed, 19 Mar 2008 23:32:42 -0400
Message-ID: <D9A1816327F7BF4F931ADE74C248DFC90A42D366@it-004.Isys.com>
In-Reply-To: <20080320000254.GC103321673@sgi.com>
From: "Jim Paradis" <jparadis@exagrid.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

David Chinner:
>On Wed, Mar 19, 2008 at 03:26:05PM -0400, Jim Paradis wrote:
>> We recently ran across a situation where we saw two directory entries
>> that were exactly the same.
>
>What kernel version?

2.6.18 .  Has this problem been root-caused and fixed in a more recent version?  Looking through the git updates in the main tree doesn't suggest to me that it has...

--jim
