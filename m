Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 19 Oct 2007 11:09:56 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9JI9oHA026195
	for <xfs@oss.sgi.com>; Fri, 19 Oct 2007 11:09:53 -0700
Message-ID: <4718F2EF.9050808@sandeen.net>
Date: Fri, 19 Oct 2007 13:09:51 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: implement fallocate V2
References: <20070713184125.GA12156@amitarora.in.ibm.com> <20070716053751.GN12413810@sgi.com>
In-Reply-To: <20070716053751.GN12413810@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

David Chinner wrote:
> Initial implementation of ->fallocate for XFS.
> 
> Version 2:
> 
> o Make allocation and setting the file size atomic.
> o Drop deallocate/punch functionality
> o use mode field appropriately to determine if size needs changing.
> 

Dave, I don't see this in CVS or in git.  Did it get lost and/or abandoned?

-Eric
