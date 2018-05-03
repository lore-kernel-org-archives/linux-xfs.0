Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34314 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751121AbeECSXc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 May 2018 14:23:32 -0400
Subject: Re: [PATCH 1/9] libfrog: move platform specific runtime support code
 out of libxfs
References: <152401952391.13048.15040850425873030425.stgit@magnolia>
 <152401953013.13048.5503819449572585211.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <79263495-6f42-4199-e5f2-27db3eea7c8a@sandeen.net>
Date: Thu, 3 May 2018 13:23:31 -0500
MIME-Version: 1.0
In-Reply-To: <152401953013.13048.5503819449572585211.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 4/17/18 9:45 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the platform support code to libfrog, which should remove the final
> dependency of libfrog on libxfs.  libfrog is the runtime support
> library, and these files provide platform support.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

